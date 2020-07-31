$(document).on('turbolinks:load', function() {

  changeDurationSelectbox();
	
  // 	turbolinkによりscrollToResult()実行後opacityが0のままになってしまうので初期化
	$('head').append(
		'<style type="text/css">.target{opacity: 1;}'
	);

  // 初回訪問時のみ実行
  if (location.pathname == "/"){
    const keyName = 'visited';
    const keyValue = true;
    if (localStorage.getItem(keyName) == null) {
      localStorage.setItem(keyName, keyValue);

      selectboxFadein();
      setTimeout(startIntro, 3300);
    }
  }
  
  scrollToResult();

});

$(document).on('change', '#condition_stock_id', function() {
  changeDurationSelectbox();
});

function selectboxFadein(){

  // プレビューモードではない場合にフェードインアニメーションを追加
  var previewElem = $("#result")
  if (previewElem[0] == null){
  	$('head').append(
  		'<style type="text/css">.target{opacity: 0;margin-top:10px;}'
  	);
    const delaySpeed = 500;
    const fadeSpeed = 400;
    $('.target').each(function(i){
        $(this).delay(i*(delaySpeed)).animate({opacity:'1',marginTop:'0px'},fadeSpeed);
    });
  }else{
      	$('head').append('<style type="text/css">.target{opacity: 1; margin-top:0px;}');
  }
}

function scrollToResult(){
	const TARGET = $("#result");
    if (TARGET[0]){
      const SPEED_MS = 400;
    	const POSITION = TARGET.offset().top;
    	const BODY_PADDING_TOP = 57
    	$('body,html').animate({scrollTop:( POSITION - BODY_PADDING_TOP)}, SPEED_MS, 'swing');
  }
}


function changeDurationSelectbox(){
  let stockIdVal = $('#condition_stock_id').val();
  //一度目に検索した内容がセレクトボックスに残っている時用のif文
  if (stockIdVal !== "") {
    let selectedTemplate = $(`#stock_${stockIdVal}`);
    $('#condition_duration').remove();
    $('#duration_form').after(selectedTemplate.html());
  }
}

function startIntro(){
  var intro = introJs();
  intro.setOptions({
  "hidePrev": true,
  "hideNext": true,
  "doneLabel": "はじめる",
  "skipLabel": "スキップ",
  "prevLabel": "＜ 戻る",
  "nextLabel": "次へ ＞",
  steps: [
    { 
      intro: '<p>ようこそ<br> TradeSimulatorへ</p><p class="first-intro">このチュートリアルでは、<br>株式の取引をシミュレーションできるTradeSimulatorの使い方をご紹介します。</p>'
    },
    {
      element: '#step1',
      intro: '<p>シミュレーションしたい銘柄を選択します。</p>',
      position: 'bottom',
    },
    {
      element: '#step2',
      intro: '<p>株価が前日からどれだけ動いたら買うか指定します。</p>',
    },
    {
      element: '#step3',
      intro: '<p>おなじように、<br>売る条件を指定します。</p>',
    },
    {
      element: '#step4',
      intro: '<p>シミュレーションを行う期間を指定します。</p><p class="annotation">※銘柄によって指定できる期間は異なります。</p>',
    },
    {
      element: '#step5',
      intro: '<p>ボタンを押すと、<br>シミュレーション結果がグラフとともに表示されます。</p>'
    }
  ]
  });

  intro.start();
}
