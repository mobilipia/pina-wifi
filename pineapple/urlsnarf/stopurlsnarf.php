<?php
exec ("echo '' > /www/pineapple/logs/urlsnarf.log");
exec ("kill `ps auxww | grep \"urlsnarf.sh\" | grep -v -e grep | awk '{print $1}'`");
exec ("killall update-urlsnarf.sh");
exec ("kill `ps auxww | grep \"urlsnarf -i br-lan\" | grep -v -e grep | awk '{print $1}'`");
?>
<html><head>
<meta http-equiv="refresh" content="0; url=/pineapple/">
</head><body bgcolor="black" text="white"><pre>
<?php
echo "El conejito de la entrop&iacute;a deja de husmear en las urls, mejor va a tomarse un mojito. :)";
?>
</pre></head></body>
