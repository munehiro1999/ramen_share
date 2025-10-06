// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import Rails from "@rails/ujs"
Rails.start()

import "@popperjs/core"
import "bootstrap"

import "./map_display";


document.addEventListener("turbo:load", function () {
  const input = document.getElementById("image-input");
  const preview = document.getElementById("image-preview");
  let selectedFiles = [];

  if (!input) return;

  input.addEventListener("change", () => {
    selectedFiles = selectedFiles.concat(Array.from(input.files));
    preview.innerHTML = "";

    selectedFiles.forEach((file, index) => {
      if (!file.type.startsWith("image/")) return;

      const reader = new FileReader();
      reader.onload = (e) => {
        const wrapper = document.createElement("div");
        wrapper.classList.add("position-relative");

        const img = document.createElement("img");
        img.src = e.target.result;
        img.classList.add("preview-image", "rounded-3");

        const btn = document.createElement("button");
        btn.innerHTML = "&times;";
        btn.classList.add("btn", "btn-sm", "btn-danger", "position-absolute", "top-0", "end-0", "m-1", "rounded-circle");

        btn.addEventListener("click", (ev) => {
          ev.preventDefault();
          selectedFiles.splice(index, 1);
          wrapper.remove();
          const data = new DataTransfer();
          selectedFiles.forEach(f => data.items.add(f));
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
    selectedFiles.forEach(f => data.items.add(f));
    input.files = data.files;
  });
});


