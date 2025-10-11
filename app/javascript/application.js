// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "./controllers"
import Rails from "@rails/ujs"
Rails.start()

import "@popperjs/core"
import "./bootstrap"
import "./map_display"
import "./map_preview"
import "./star_rating"



document.addEventListener("turbo:load", function () {
  const input = document.getElementById("image-input");
  const preview = document.getElementById("image-preview");
  // 編集時も残すため、selectedFiles はページロード後に空にせず維持
  window.selectedFiles = window.selectedFiles || [];

  if (!input || !preview) return;

  // 既存画像削除ボタン
  preview.querySelectorAll(".existing-delete-btn").forEach(btn => {
    btn.addEventListener("click", (e) => {
      e.preventDefault();
      const wrapper = btn.closest(".existing-image-wrapper");
      const imageId = btn.dataset.imageId;

      // Rails 側で削除処理用 hidden input を作成
      const hiddenInput = document.createElement("input");
      hiddenInput.type = "hidden";
      hiddenInput.name = "deleted_image_ids[]";
      hiddenInput.value = imageId;
      preview.appendChild(hiddenInput);

      wrapper.remove();
    });
  });

  // 新規画像選択
  input.addEventListener("change", () => {
    const files = Array.from(input.files);
    files.forEach(f => window.selectedFiles.push(f));

    // 古い新規プレビューを削除（既存画像は残す）
    preview.querySelectorAll(".new-image-wrapper").forEach(el => el.remove());

    window.selectedFiles.forEach((file) => {
      if (!file.type.startsWith("image/")) return;

      const reader = new FileReader();
      reader.onload = (e) => {
        const wrapper = document.createElement("div");
        wrapper.classList.add("position-relative", "me-2", "mb-2", "new-image-wrapper");

        const img = document.createElement("img");
        img.src = e.target.result;
        img.classList.add("rounded-3");
        img.style.objectFit = "cover";
        img.style.height = "200px;"
        img.style.width = "200px";
        img.style.width = "auto";

        const btn = document.createElement("button");
        btn.type = "button";
        btn.innerHTML = "&times;";
        btn.classList.add("btn", "btn-sm", "btn-danger", "position-absolute", "top-0", "end-0", "m-1", "rounded-circle");

        btn.addEventListener("click", (ev) => {
          ev.preventDefault();
          // 選択画像から削除
          window.selectedFiles = window.selectedFiles.filter(f => f !== file);
          wrapper.remove();

          // input.files を更新
          const data = new DataTransfer();
          window.selectedFiles.forEach(f => data.items.add(f));
          input.files = data.files;
        });

        wrapper.appendChild(img);
        wrapper.appendChild(btn);
        preview.appendChild(wrapper);
      };
      reader.readAsDataURL(file);
    });

    // 同じファイル再選択対応
    input.value = "";
    const data = new DataTransfer();
    window.selectedFiles.forEach(f => data.items.add(f));
    input.files = data.files;
  });
});


