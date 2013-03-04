$(document).ready (function (){
  var gameOver = false
  $('td').click(function (){
    $('.begin').hide();
    if ($(this).text() == "X" || $(this).text() == "O" ) {
    return false; 
    } else if (gameOver == true) {
      return false;
    } else {
      $(this).text("X");
    }
    
    var id = $(this).attr('id');
    
    $.post('/game', {human_position: id}, function(serverResponse){
          gameOver = serverResponse.game_over
          console.log("game over?:" + serverResponse.game_over);
          console.log("winner:" + serverResponse.winner);
      if (serverResponse.game_over) {
        console.log(serverResponse.game_over);
        $('.gameover').show();
        $('.reset').show();
        $('.winner').text(serverResponse.winner)
        $('.winner').show();
      }
      console.log(serverResponse.computer_position);
      var nextMove = 'td#' + serverResponse.computer_position;
      console.log(nextMove);
      if ($(nextMove).text() == "X" || $(nextMove).text() == "O"){

      } else {
      $(nextMove).text('O');
      }

    });

  });

});
