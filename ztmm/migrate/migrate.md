
## Download images

```bash
python3 download_images.py
```

```
image_download/
├── download_images.py
├── images.csv
├── images_downloaded.csv
└── downloaded_images/
    ├── 01___Introduction_Section_image.jpg
    ├── 02___Introduction_Section_background.jpg
    ├── 03___Services_Service_1.jpg
    ├── ...
    ├── 14_blog_...jpg
    └── 15_blog_...jpg
```

## Replace images

```bash
mkdir -p assets/images
mv downloaded_images/* assets/images/
python3 update_image_references.py
```

```
# python3 update_image_references.py
zetianmiaomu/
├── index.html
├── blog.html
├── assets/
│   ├── site.css
│   ├── bootstrap.bundle.min.js
│   └── images/
└── blog/
    ├── -9c06deb1.html
    ├── 2024-4daa6343.html
    └── -7e64aeef.html
```

## Start afresh

```bash
cd ~/Downloads
cp ~/jinghuazhao.github.io/docs/zetianmiaomu/images.csv .
python3 ~/jinghuazhao.github.io/docs/zetianmiaomu/download_images.py
module load ceuadmin/python/3.14.10
python3 migrate_solo_site.py \
  ~/Downloads/solo-websites-20261118203431.zip \
  --images ~/Downloads/downloaded_images \
  --output ~/tests/zetianmiaomu
```

## Amend mapholders

```bash
cd ~/tests/zetianmiaomu

python3 - <<'PY'
from pathlib import Path
import re

src = Path("index.orig")
dst = Path("index.html")
s = src.read_text(encoding="utf-8")

# 1. Telephone number followed by direct map links
old = 'href="tel:☎️18865572666 (谷歌地图)">☎️18865572666 (谷歌地图)'
new = (
    'href="tel:18865572666">☎️18865572666</a>'
    '（<a href="https://uri.amap.com/marker?position=121.3453,37.40735&name=泽田苗木&src=website" '
    'target="_blank" rel="noopener">高德地图</a>'
    ' / <a href="https://www.google.com/maps/search/?api=1&query=%E8%A5%BF%E9%99%8C%E5%A0%82%E6%9D%91%2C%E7%A6%8F%E5%B1%B1%E5%8C%BA%2C%E7%83%9F%E5%8F%B0%E5%B8%82%2C%E5%B1%B1%E4%B8%9C%E7%9C%81" '
    'target="_blank" rel="noopener">Google Maps</a>）'
)
nt = s.count(old)
s = s.replace(old, new)

# 2. Remove the contact-section map placeholder
s, n1 = re.subn(
    r'<div role="note" data-solo-export-placeholder="true" style="height:100%;min-height:358px.*?</div></div>',
    '</div>', s, count=1, flags=re.S
)

# 3. Remove the obsolete map embed section and its heading
s, n2 = re.subn(
    r'<div[^>]*id="codeembed-1"[^>]*>.*?</div></div></div></div></div>',
    '',
    s, count=1, flags=re.S
)

# 4. Remove any remaining standalone map heading
s, n3 = re.subn(
    r'<h[1-6]\b[^>]*>\s*高德地图\s*\(Amap，点击进入导航\)\s*</h[1-6]>',
    '', s, count=1
)

# Validate before writing
if nt != 1 or n1 != 1:
    raise SystemExit(
        f"Stopped: telephone={nt}, contact placeholder={n1}. "
        "No output written; check index.orig."
    )

dst.write_text(s, encoding="utf-8")
print("Created index.html from index.orig.")
print(f"Telephone link: {nt}; contact placeholder: {n1}")
print(f"Old map section: {n2}; old heading: {n3}")
PY
```

## Check results

```bash
python3 -m http.server 8000 &
firefox http://localhost:8000/ &
zip -r zetianmiaomu-local.zip \
    index.html blog.html blog assets images.csv \
    images_downloaded.csv README-local.txt
```
