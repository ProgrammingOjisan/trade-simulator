$(document).on('turbolinks:load', function() {
  let stockIdVal = $('#condition_stock_id').val();
  //一度目に検索した内容がセレクトボックスに残っている時用のif文
  if (stockIdVal !== "") {
    let selectedTemplate = $(`#stock_${stockIdVal}`);
    $('#condition_duration').remove();
    $('#duration_form').after(selectedTemplate.html());
  };
  $(document).on('change', '#condition_stock_id', function() {
      console.log("success")
      let stockIdVal = $('#condition_stock_id').val();
      if (stockIdVal !== "") {
          let selectedTemplate = $(`#stock_${stockIdVal}`);
          $('#condition_duration').remove();
          $('#duration_form').after(selectedTemplate.html());
      };
  });
}); 