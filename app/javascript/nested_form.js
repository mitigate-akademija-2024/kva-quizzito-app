document.addEventListener("DOMContentLoaded", () => {
  const addQuestionButton = document.getElementById("add-question");
  const questionsDiv = document.getElementById("questions");
  let questionCount = document.querySelectorAll(".nested-fields").length;

  // Add Question
  addQuestionButton.addEventListener("click", (e) => {
    e.preventDefault();

    if (questionCount < 15) {
      const time = new Date().getTime();
      const regexp = new RegExp("new_questions", "g");
      const newQuestionFields = document.createElement("div");

      newQuestionFields.innerHTML = questionsDiv.dataset.fields.replace(regexp, time);
      questionsDiv.appendChild(newQuestionFields);

      questionCount += 1;
    } else {
      alert("You can only add up to 15 questions.");
    }
  });

  // Remove Question
  document.addEventListener("click", (e) => {
    if (e.target.classList.contains("remove-question")) {
      e.preventDefault();
      e.target.closest(".nested-fields").remove();
      questionCount -= 1;
    }
  });
});
