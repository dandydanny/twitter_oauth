$(document).ready(function() {
  console.log("js ready");
  // This is called after the document has loaded in its entirety
  // This guarantees that any elements we bind to will exist on the page
  // when we try to bind to them
  $("#tweet-form").submit(function(e) {
    e.preventDefault();
    console.log("Something submitted...");
    console.log("About to do AJAX post =========");

    // $("tweet").val();
    // $.post("/tweet", $("form").serialize(), function(data) {
    //   console.log(data);
    //   $("#all-good").toggle();
    // })

    // not a hash
    $.ajax({
      type: "POST",
      url: "/tweet",
      data: $("form").serialize(),  //tweet=zxczxc
      success: function(returnData) {
        console.log("great success!");
        $("#status").html("<p>Tweeted!</p>")
      }
    });
  });
});
