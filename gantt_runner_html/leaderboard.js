(function () {
  const dialog = document.getElementById("submit-dialog");
  const cancel = document.getElementById("cancel");
  const closeDialog = document.getElementById("close");
  const leaderboard = document.getElementById("leaderboard");
  const details = document.getElementById("details");
  const scoreForm = document.getElementById("score-form");
  const iframe = document.getElementById("iframe");
  const statsUi = {
    id: document.getElementById("id"),
    level: document.getElementById("level"),
    score: document.getElementById("score"),
    time: document.getElementById("time"),
    character: document.getElementById("character"),
  };

  // prevents bug on mobile
  dialog.addEventListener("touchstart", (e) => {
    e.stopPropagation();
  });

  cancel.addEventListener("click", (e) => {
    e.stopPropagation();

    dialog.close();
    details.style.display = "block";
    leaderboard.style.display = "none";
  });

  closeDialog.addEventListener("click", (e) => {
    e.stopPropagation();

    dialog.close();
    details.style.display = "block";
    leaderboard.style.display = "none";
  });

  window.addEventListener("levelcomplete", (e) => {
    submitStats(e.detail);
  });

  scoreForm.addEventListener("submit", (e) => {
    e.stopPropagation();
    e.preventDefault();

    fetch(`https://knownasilya-saveSgrScorePost.web.val.run`, {
      method: "post",
      body: new FormData(scoreForm),
    })
      .then((res) => {
        console.log(res);

        details.style.display = "none";
        leaderboard.style.display = "block";

        // reload it
        const existingUrl = new URL(iframe.src);
        const level = document.getElementById("level").textContent.trim();
        existingUrl.searchParams.set("level", level);

        iframe.src = existingUrl.toString();
      })
      .catch((err) => {
        console.error(err);
      });
  });

  function submitStats(stats) {
    const data = new FormData();
    data.append("id", stats.id);
    data.append("level", stats.level);
    data.append("character", stats.character);
    data.append("score", stats.score);
    data.append("time", stats.time);

    fetch(`https://knownasilya-sgrSubmit.web.val.run`, {
      method: "post",
      body: data,
    })
      .then(async (res) => {
        const result = await res.json();

        if (!result?.isHighScore) return;

        statsUi.id.value = result.id;
        statsUi.level.textContent = stats.level;
        statsUi.score.textContent = stats.score;
        statsUi.time.textContent = stats.time;
        statsUi.character.textContent = stats.character;

        if (dialog) {
          dialog.showModal();
        }
      })
      .catch((err) => {
        console.error(err);
      });
  }
})();
