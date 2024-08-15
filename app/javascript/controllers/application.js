document.addEventListener('DOMContentLoaded', () => {
    const addQuestionButton = document.querySelector('#add-question');

    // Check if the add question button exists
    if (addQuestionButton) {
        addQuestionButton.addEventListener('click', handleAddQuestionClick);
    }

    // Bind remove button listeners for existing questions and answers
    addRemoveListeners();

    // Add listener for adding answers
    document.querySelectorAll('.add-answer').forEach(button => {
        button.addEventListener('click', handleAddAnswerClick);
    });
});

function addRemoveListeners() {
    document.querySelectorAll('.remove-question').forEach(button => {
        button.removeEventListener('click', handleRemoveClick);  // Prevent duplicate listeners
        button.addEventListener('click', handleRemoveClick);
    });

    document.querySelectorAll('.remove-answer').forEach(button => {
        button.removeEventListener('click', handleRemoveClick);  // Prevent duplicate listeners
        button.addEventListener('click', handleRemoveClick);
    });
}


function handleRemoveClick(e) {
    e.preventDefault();
    const fieldContainer = e.currentTarget.closest('.question-fields') || e.currentTarget.closest('.answer-fields');
    if (fieldContainer) {
        fieldContainer.remove();
    }
}

function removeFields(link) {
    const fieldContainer = link.closest('.question-fields') || link.closest('.answer-fields');
    if (fieldContainer) {
        fieldContainer.remove();
    }
}

function handleAddQuestionClick(e) {
    e.preventDefault();
    const questionContainer = document.querySelector("#questions");
    const questionIndex = questionContainer.children.length;
    const newQuestion = questionContainer.children[0].cloneNode(true);

    // Clear all text and textarea fields
    newQuestion.querySelectorAll('input[type="text"], textarea').forEach((input) => {
        input.value = "";
        input.name = input.name.replace(/\[\d+\]/, `[${questionIndex}]`);
        input.id = input.id.replace(/_\d+_/, `_${questionIndex}_`);
    });

    // Uncheck all checkboxes
    newQuestion.querySelectorAll('input[type="checkbox"]').forEach((input) => {
        input.checked = false;
        input.name = input.name.replace(/\[\d+\]/, `[${questionIndex}]`);
        input.id = input.id.replace(/_\d+_/, `_${questionIndex}_`);
    });

    // Clear hidden ID fields to avoid conflicts
    newQuestion.querySelectorAll('input[type="hidden"]').forEach((input) => {
        if (input.name.endsWith("[id]")) {
            input.value = ""; // Clear the hidden ID field
        }
    });

    // Ensure any add-answer buttons work on the newly cloned question
    newQuestion.querySelectorAll(".add-answer").forEach((button) => {
        button.addEventListener("click", handleAddAnswerClick);
    });

    // Append the new question to the container
    questionContainer.appendChild(newQuestion);

    // Rebind remove listeners to ensure the remove buttons work correctly
    addRemoveListeners();
}

function handleAddAnswerClick(e) {
    e.preventDefault();
    const answerContainer = e.currentTarget.closest('.question-fields').querySelector('.answers');
    const answerIndex = answerContainer.children.length;
    const newAnswer = answerContainer.children[0].cloneNode(true);

    // Generate a unique timestamp to ensure unique field names and IDs
    const timestamp = new Date().getTime();

    // Clear the values in the cloned fields and update names and IDs
    newAnswer.querySelectorAll('input[type="text"]').forEach((input) => {
        input.value = '';
        input.name = input.name.replace(/\[\d+\]/, `[${answerIndex}]`);
        input.id = input.id.replace(/_\d+_/, `_${answerIndex}_`);
    });

    newAnswer.querySelectorAll('input[type="checkbox"]').forEach((input) => {
        input.checked = false;
        input.name = input.name.replace(/\[\d+\]/, `[${answerIndex}]`);
        input.id = input.id.replace(/_\d+_/, `_${answerIndex}_`);
    });

    // Clear the hidden ID fields to avoid conflicts
    newAnswer.querySelectorAll('input[type="hidden"]').forEach((input) => {
        if (input.name.endsWith("[id]")) {
            input.value = '';  // Clear the ID field
        }
    });

    answerContainer.appendChild(newAnswer);

    // Rebind remove event to the new remove buttons
    addRemoveListeners();
}



// Configure Stimulus development experience
application.debug = false
window.Stimulus = application

export { application }
