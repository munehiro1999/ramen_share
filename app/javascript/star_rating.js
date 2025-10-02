document.addEventListener("turbo:load", function () {
  const stars = document.querySelectorAll("#star-rating .star");
  const input = document.getElementById("rating-input");

  function updateStars(rating) {
    stars.forEach((star) => {
      const value = parseFloat(star.dataset.value);
      if (value <= rating) {
        star.classList.add("text-warning");
        star.classList.remove("text-secondary");
      } else {
        star.classList.add("text-secondary");
        star.classList.remove("text-warning");
      }
    });
  }

  stars.forEach((star) => {
    star.addEventListener("click", () => {
      const value = parseFloat(star.dataset.value);
      input.value = value;
      updateStars(value);
    });

    star.addEventListener("mouseover", () => {
      const value = parseFloat(star.dataset.value);
      updateStars(value);
    });
  });

  document.getElementById("star-rating").addEventListener("mouseleave", () => {
    updateStars(parseFloat(input.value));
  });

  // 初期表示
  updateStars(parseFloat(input.value));
});
