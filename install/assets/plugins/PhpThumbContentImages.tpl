/**
 * PhpThumbContentImages
 *
 * Use phpthumb for Images in the content field
 *
 * @author    Nicola Lambathakis
 * @category    plugin
 * @version    1.0
 * @license	 http://www.gnu.org/copyleft/gpl.html GNU Public License (GPL)
 * @internal    @events OnLoadWebDocument
 * @internal    @installset base
 * @internal    @modx_category Images
 * @internal    @properties  &ImageSizes=Use image sizes from:;menu;imageAttribute,phpthumbParams;phpthumbParams &ImageW=Image width:;string;1200 &ImageH=Image height:;string;400 &ImageQ=Image quality:;string;80 &ImageZC=Image Zoom crop:;string;T &ImageF=Image Format:;string;webp &ImageClass= Image Class:;string;img-fluid 
 */

/*
###PhpThumbContentImages for Evolution CMS###
Written By Nicola Lambathakis: http://www.tattoocms.it
Version 1.0 
*/

$e= & $modx->Event;
switch ($e->name) {
case "OnLoadWebDocument":
	    //check if it is an text/html document
	if ($modx->documentObject['contentType'] != 'text/html') {
			break;
		}
	    //Get the output from the content 
		$o = &$modx->documentObject['content'];
			$dom = new DOMDocument();
			$dom->loadHTML(mb_convert_encoding($o, 'HTML-ENTITIES', 'UTF-8'));
			$dom->loadHTML($o);
		//Search img tag and src attribute (image url)
			$imgTags = $dom->getElementsByTagName('img');
			foreach ($imgTags as $imgTag) {
			$old_src = $imgTag->getAttribute('src');
		//check wich image sizes use 
		if ($ImageSizes == 'imageAttribute') {
			$ImageW = $imgTag->getAttribute('width');
			$ImageH = $imgTag->getAttribute('height');
		} else {
			$imgTag->setAttribute('width', $ImageW);
			$imgTag->setAttribute('height', $ImageH);
		}
		// Add new or modifies image class 
		if ($ImageClass != '') {
			$imgTag->setAttribute('class', $ImageClass);
		}
		//Run phpthumb	
			$new_src = $modx->runSnippet("phpthumb", array('input'=>''.$old_src.'', 'options'=>'aoe=1,w='.$ImageW.',h='.$ImageH.',q='.$ImageQ.',zc='.$ImageZC.',f='.$ImageF.'', 'adBlockFix'=>'1'));
		//Replace img src url with phpthumb 	
			$imgTag->setAttribute('src', $new_src);

	 }
		$o = $dom->saveHTML();
				
		break;
	default :
		return; // stop here
		break;
}