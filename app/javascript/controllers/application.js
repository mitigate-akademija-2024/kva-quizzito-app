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
    removeFields(e.currentTarget);
}

function removeFields(link) {
    const fieldContainer = link.closest('.question-fields') || link.closest('.answer-fields');
    if (fieldContainer) {
        fieldContainer.remove();
    }
}

function handleAddQuestionClick(e) {
    e.preventDefault();
    const questionContainer = document.querySelector('#questions');
    const newQuestion = questionContainer.children[0].cloneNode(true);

    // Generate a unique timestamp to ensure unique field names
    const timestamp = new Date().getTime();

    // Clear the values in the cloned fields and update names and IDs
    newQuestion.querySelectorAll('input[type="text"], textarea').forEach(input => {
        input.value = '';
        input.name = updateFieldName(input.name, timestamp);
        input.id = updateFieldID(input.id, timestamp);
    });

    newQuestion.querySelectorAll('input[type="checkbox"]').forEach(input => {
        input.checked = false;
        input.name = updateFieldName(input.name, timestamp);
        input.id = updateFieldID(input.id, timestamp);
    });

    // Clear the hidden ID fields (if any)
    newQuestion.querySelectorAll('input[type="hidden"]').forEach(input => {
        if (input.name.endsWith("[id]")) {
            input.value = '';  // Clear the ID field
        }
    });

    // Update add-answer buttons and remove-answer buttons
    newQuestion.querySelectorAll('.add-answer').forEach(button => {
        button.addEventListener('click', handleAddAnswerClick);
    });

    questionContainer.appendChild(newQuestion);

    // Rebind remove event to the new remove buttons
    addRemoveListeners();
}

function handleAddAnswerClick(e) {
    e.preventDefault();
    const answerContainer = e.currentTarget.closest('.question-fields').querySelector('.answers');
    const newAnswer = answerContainer.children[0].cloneNode(true);

    // Generate a unique timestamp to ensure unique field names
    const timestamp = new Date().getTime();

    // Clear the values in the cloned fields and update names and IDs
    newAnswer.querySelectorAll('input[type="text"]').forEach(input => {
        input.value = '';
        input.name = updateFieldName(input.name, timestamp);
        input.id = updateFieldID(input.id, timestamp);
    });

    newAnswer.querySelectorAll('input[type="checkbox"]').forEach(input => {
        input.checked = false;
        input.name = updateFieldName(input.name, timestamp);
        input.id = updateFieldID(input.id, timestamp);
    });

    // Clear the hidden ID fields (if any)
    newAnswer.querySelectorAll('input[type="hidden"]').forEach(input => {
        if (input.name.endsWith("[id]")) {
            input.value = '';  // Clear the ID field
        }
    });

    answerContainer.appendChild(newAnswer);

    // Rebind remove event to the new remove buttons
    addRemoveListeners();
}

function updateFieldName(name, timestamp) {
    return name.replace(/\[\d+\]/g, `[${timestamp}]`);
}

function updateFieldID(id, timestamp) {
    return id ? id.replace(/_\d+_/, `_${timestamp}_`) : id;
}

// Configure Stimulus development experience
application.debug = false
window.Stimulus = application

export { application }
