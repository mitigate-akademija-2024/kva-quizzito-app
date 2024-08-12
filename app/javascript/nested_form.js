document.addEventListener('turbo:load', function() {
    document.querySelector('.add_fields').addEventListener('click', function(e) {
      e.preventDefault();
      console.log("Add fields clicked");
  
      const link = e.target;
      const association = link.dataset.association;
      const qustion_text = link.dataset.question_text;
  
      console.log(association, question_text);
  
      addFields(link, association, question_text);
    });
  });
  