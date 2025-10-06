document.addEventListener("turbo:load", () => {
  initMap();
});

function initMap() {
  // --- 投稿フォームプレビュー ---
  const mapPreviewElement = document.getElementById("map-preview");
  if (mapPreviewElement) {
    const addressInput = document.getElementById("ramen_post_address");
    const latInput = document.getElementById("ramen_post_latitude");
    const lngInput = document.getElementById("ramen_post_longitude");

    const geocoder = new google.maps.Geocoder();

    const map = new google.maps.Map(mapPreviewElement, {
      zoom: 15,
      center: { lat: 35.681236, lng: 139.767125 },
    });

    const marker = new google.maps.Marker({
      map: map,
      position: map.getCenter(),
    });

    // 住所入力でマップ更新
    if (addressInput) {
      addressInput.addEventListener("input", () => {
        const address = addressInput.value;
        if (!address) return;

        geocoder.geocode({ address }, (results, status) => {
          if (status === "OK" && results[0]) {
            const loc = results[0].geometry.location;
            map.setCenter(loc);
            marker.setPosition(loc);

            latInput.value = loc.lat();
            lngInput.value = loc.lng();
          }
        });
      });
    }

    // 編集ページで初期値がある場合
    const initialLat = parseFloat(latInput.value);
    const initialLng = parseFloat(lngInput.value);
    if (initialLat && initialLng) {
      const initLoc = { lat: initialLat, lng: initialLng };
      map.setCenter(initLoc);
      marker.setPosition(initLoc);
    }
  }

  // --- 詳細ページマップ ---
  const mapDetailElement = document.getElementById("map");
  if (mapDetailElement) {
    const lat = parseFloat(mapDetailElement.dataset.latitude) || 35.681236;
    const lng = parseFloat(mapDetailElement.dataset.longitude) || 139.767125;

    const center = { lat, lng };
    const map = new google.maps.Map(mapDetailElement, {
      zoom: 15,
      center: center,
    });

    new google.maps.Marker({
      position: center,
      map: map,
    });
  }
}

// Google Maps API callback 用にグローバル登録
window.initMap = initMap;
