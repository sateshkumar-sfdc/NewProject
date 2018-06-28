<!DOCTYPE html>
<!-- saved from url=(0056)https://customize-staging.yeticustomshop.com/widget.html -->
<html><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Customizer Test</title>
    
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <style>
        body {
            text-align: center;
        }
    </style>
</head>
<body>
<p>
    <button data-open="">Open Widget</button>
    <button data-close="">Close Widget</button>
</p>
<div class="widget"><iframe id="yeti-customizer" style="width: 100%; padding: 0px; margin: 0px; border: none; min-height: 200px; overflow: hidden; height: 628.359px;" src="./Customizer Test_files/saved_resource.html"></iframe></div>
<script src="./Customizer Test_files/widget.js.download"></script>
<script>
    YETI.customizer.init({
        selector: '.widget', // DOM selector to display the customizer in
        product: 'rambler-wine-tumbler-10oz', // UPK

        // Do something once widget has loaded (optional)
        onReady: () => {
            document.querySelector('[data-open]').onclick = YETI.customizer.open;
            document.querySelector('[data-close]').onclick = YETI.customizer.close;
            YETI.customizer.open({
                //data: ["{\"version\":\"2.0\",\"customtype\":\"monogram\",\"ramsideloc\":\"front\",\"productkey\":\"rambler-wine-tumbler-10oz\",\"ramvertloc\":\"auto\",\"ramorientation\":\"auto\",\"custpreview\":\"https://rambleron-staging.s3.amazonaws.com/flat_images/2018/05-02/6382-1525278907-large.png\",\"warpedpreview\":\"https://s3.amazonaws.com/rambleron-staging/approval_images/2018/05-02/6382/1525278907-large.png\",\"previewid\":6382,\"previewurl\":\"https://store-staging.rambleron.com/api/v2/customizations/6382?type=monogram\",\"monogram\":{\"rawtext\":\"ACB\",\"translatedtext\":\"aB3\",\"basefont\":\"circle\",\"font\":\"three-character-circle\",\"size\":\"auto\"}}"]
            });
        },

        // Do something with the data upon clicking the "Approve" button
        onApprove: data => console.dir(data)
    });
</script>

</body></html>