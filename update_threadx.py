import tempfile
import requests
import shutil
from pathlib import Path
import os

REPO = "azure-rtos/threadx"
ARCH_LIST = ["cortex_m0", "cortex_m4", "cortex_m7"]


def main():
    # get latest release information
    r = requests.get(f"https://api.github.com/repos/{REPO}/releases/latest")
    release_info = r.json()

    tag_name = release_info["tag_name"]
    zipball_url = release_info["zipball_url"]

    print(f"The latest Azure RTOS ThreadX version is {tag_name}")

    # get a temporary directory
    tempdir = Path(tempfile.gettempdir())

    zipball_path = tempdir / f"threadx_{tag_name}.zip"
    threadx_path = tempdir / f"threadx_{tag_name}"

    print("Downloading the latest ThreadX version...")

    # download zip file of latest release
    r = requests.get(zipball_url)
    with open(str(zipball_path), "wb") as f:
        f.write(r.content)

    print("Unzipping")

    # unzip threadx
    shutil.unpack_archive(str(zipball_path), str(threadx_path))

    # get the first directory in the zip (where the repo contents are)
    threadx_path = Path(threadx_path.iterdir().__next__())

    print("Copying files")

    tx_src_common = str(threadx_path / "common" / "src")
    tx_inc_common = str(threadx_path / "common" / "inc")

    src_common = str(Path(".") / "src" / "common")
    inc_common = str(Path(".") / "include" / "common")

    try:
        shutil.rmtree(src_common)
    except FileNotFoundError:
        pass
    try:
        shutil.rmtree(inc_common)
    except FileNotFoundError:
        pass

    # copy common/src to src
    shutil.copytree(tx_src_common, src_common)
    # copy common/inc to include
    shutil.copytree(tx_inc_common, inc_common)

    for arch in ARCH_LIST:
        tx_src_port = str(threadx_path / "ports" / arch / "gnu" / "src")
        src_port = str(Path(".") / "ports" / arch / "src")

        try:
            shutil.rmtree(src_port)
        except FileNotFoundError:
            pass

        shutil.copytree(tx_src_port, src_port)

        inc_port = Path(".") / "ports" / arch / "include"
        os.mkdir(str(inc_port))
        shutil.copyfile(
            str(threadx_path / "ports" / arch / "gnu" / "inc" / "tx_port.h"),
            str(inc_port / "tx_port.h"),
        )


if __name__ == "__main__":
    main()
