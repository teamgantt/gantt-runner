import * as leaderboardService from "./leaderboard-service.js";

(function () {
  const dialog = document.getElementById("submit-dialog");
  const cancel = document.getElementById("cancel");
  const closeDialog = document.getElementById("close");
  const leaderboard = document.getElementById("leaderboard");
  const details = document.getElementById("details");
  const scoreForm = document.getElementById("score-form");
  const iframe = document.getElementById("iframe");
  const statsUi = {
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

  window.addEventListener("levelwon", async (e) => {
    const stats = e.detail;
    const isHighScore = await leaderboardService.isHighScore(
      stats.level,
      stats.score
    );

    if (isHighScore) {
      statsUi.level.textContent = stats.level;
      statsUi.score.textContent = stats.score;
      statsUi.time.textContent = stats.time;
      statsUi.character.textContent = stats.character;

      scoreForm.level.value = stats.level;
      scoreForm.score.value = stats.score;
      scoreForm.time.value = stats.time;
      scoreForm.character.value = stats.character;

      if (dialog) {
        dialog.showModal();
      }
    }
  });

  scoreForm.addEventListener("submit", async (e) => {
    e.stopPropagation();
    e.preventDefault();

    const level = scoreForm.level.value;
    const name = scoreForm.name.value;
    const score = scoreForm.score.value;
    const character = scoreForm.character.value;
    const time = scoreForm.time.value;

    await leaderboardService.submitScore(level, {
      name,
      score,
      character,
      time,
    });

    const topScores = await leaderboardService.getScores(level);

    // TODO: rebuild scoreboard UI

    // details.style.display = "none";
    // leaderboard.style.display = "block";

    // // reload it
    // const existingUrl = new URL(iframe.src);
    // const level = document.getElementById("level").textContent.trim();
    // existingUrl.searchParams.set("level", level);

    // iframe.src = existingUrl.toString();
  });
})();
