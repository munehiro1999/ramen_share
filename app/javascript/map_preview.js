document.addEventListener("turbo:load", () => {
  const addressInput = document.getElementById("ramen_post_address");
  const latInput = document.getElementById("ramen_post_latitude");
  const lngInput = document.getElementById("ramen_post_longitude");
  const mapElement = document.getElementById("map-preview");

  if (!addressInput || !mapElement) return;

  // Google Maps Geocoder
  const geocoder = new google.maps.Geocoder();

  // 初期マップ
  const map = new google.maps.Map(mapElement, {
    zoom: 15,
    center: { lat: 35.681236, lng: 139.767125 }, // 東京駅など初期位置
  });

  const marker = new google.maps.Marker({
    map: map,
    position: map.getCenter(),
  });

  // 住所が入力されたらマップ更新
  addressInput.addEventListener("input", () => {
    const address = addressInput.value;
    if (!address) return;

    geocoder.geocode({ address }, (results, status) => {
      if (status === "OK" && results[0]) {
        const location = results[0].geometry.location;

        // マップ移動＆マーカー更新
        map.setCenter(location);
        marker.setPosition(location);

        // hiddenに緯度経度をセット
        latInput.value = location.lat();
        lngInput.value = location.lng();
      }
    });
  });

  // もし編集ページで初期値がある場合は初期マップ更新
  const initialLat = parseFloat(latInput.value);
  const initialLng = parseFloat(lngInput.value);
  if (initialLat && initialLng) {
    const initLocation = { lat: initialLat, lng: initialLng };
    map.setCenter(initLocation);
    marker.setPosition(initLocation);
  }
});
