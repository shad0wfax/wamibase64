/* 
* Copyright (c) 2011
* Spoken Language Systems Group
* MIT Computer Science and Artificial Intelligence Laboratory
* Massachusetts Institute of Technology
*
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without
* restriction, including without limitation the rights to use, copy,
* modify, merge, publish, distribute, sublicense, and/or sell copies
* of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
* BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
* ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
* CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*/
package edu.mit.csail.wami.record
{	
	import edu.mit.csail.wami.utils.External;
	import edu.mit.csail.wami.utils.Pipe;
	import edu.mit.csail.wami.utils.StateListener;
	
	import flash.utils.ByteArray;
	
	import mx.utils.Base64Encoder;
	
	/**
	 * Write data and POST on close.
	 */
	public class Base64Audio extends Pipe
	{	
		private var listener:StateListener;

		private var finished:Boolean = false;
		private var buffer:ByteArray = new ByteArray();
		
		private var base64Data:String;
		
		public function Base64Audio(listener:StateListener)
		{
			this.listener = listener;
		}
		
		override public function write(bytes:ByteArray):void
		{
			bytes.readBytes(buffer, buffer.length, bytes.bytesAvailable);
		}
		
		override public function close():void 
		{
			buffer.position = 0;
			External.debug("Base64 Encoding length " + buffer.length);
			buffer.position = 0;
			
			if (buffer.bytesAvailable == 0) {
				External.debug("No data, so encoding to empty string.");
				base64Data = "";
			} else {	
				var base64:Base64Encoder = new Base64Encoder();
				base64.encodeBytes(buffer);
				base64Data = base64.toString();
				External.debug("Base64 encoded string = " + base64Data);
			}
			super.close();
			listener.finished();
			finished = true;
		}
		
		public function getBase64Audio():String 
		{
			return base64Data;
		}
		
	}		
}