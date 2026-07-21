"""Utilitas untuk request HTTP, logging, dan penyimpanan JSON."""

import json
import logging
import time
from pathlib import Path
from typing import Any

import requests

from config import MAX_RETRIES, REQUEST_TIMEOUT_SECONDS, RETRY_BACKOFF_SECONDS, USER_AGENT


LOGGER = logging.getLogger(__name__)
RETRYABLE_STATUS_CODES = {429, 500, 502, 503, 504}


def configure_logging() -> None:
    """Mengatur format logging yang konsisten untuk aplikasi."""
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
    )


def create_session() -> requests.Session:
    """Membuat session HTTP dengan User-Agent yang jelas."""
    session = requests.Session()
    session.headers.update({"User-Agent": USER_AGENT, "Accept-Language": "en-US,en;q=0.9"})
    return session


def fetch_html(
    session: requests.Session,
    url: str,
    timeout: int = REQUEST_TIMEOUT_SECONDS,
) -> str | None:
    """Mengambil HTML dengan maksimal tiga percobaan pada kegagalan sementara."""
    for attempt in range(1, MAX_RETRIES + 1):
        try:
            response = session.get(url, timeout=timeout)

            if response.status_code == 404:
                LOGGER.error("Halaman tidak ditemukan (404): %s", url)
                return None

            if response.status_code in RETRYABLE_STATUS_CODES:
                raise requests.HTTPError(
                    f"Status HTTP sementara {response.status_code}", response=response
                )

            response.raise_for_status()
            return response.text
        except (requests.ConnectionError, requests.Timeout) as error:
            LOGGER.warning("Request gagal (%s/%s) untuk %s: %s", attempt, MAX_RETRIES, url, error)
        except requests.HTTPError as error:
            LOGGER.warning("HTTP error (%s/%s) untuk %s: %s", attempt, MAX_RETRIES, url, error)
        except requests.RequestException as error:
            LOGGER.error("Request tidak dapat diproses untuk %s: %s", url, error)
            return None

        if attempt < MAX_RETRIES:
            backoff = RETRY_BACKOFF_SECONDS * attempt
            LOGGER.info("Menunggu %.1f detik sebelum retry.", backoff)
            time.sleep(backoff)

    LOGGER.error("Gagal mengambil halaman setelah %s percobaan: %s", MAX_RETRIES, url)
    return None


def wait_between_requests(delay_seconds: float) -> None:
    """Memberi jeda antar-request agar scraping tidak berlebihan."""
    if delay_seconds > 0:
        time.sleep(delay_seconds)


def write_json(data: list[dict[str, Any]], output_path: Path) -> None:
    """Menyimpan data bersih sebagai JSON UTF-8 dengan indentasi."""
    output_path.parent.mkdir(parents=True, exist_ok=True)
    with output_path.open("w", encoding="utf-8") as output_file:
        json.dump(data, output_file, ensure_ascii=False, indent=2)
        output_file.write("\n")
