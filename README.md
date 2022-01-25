# keyboard-device-in-assembly
![alt text](https://github.com/ezecson/keyboard-device-in-assembly/blob/master/demo/running%20the%20driver.gif)
## table of content
- [general info](#general-info)
- [technologies](#technologies)
- [download](#download)
- [featurs](#featurs)
- [demo](#demo)
## general info
This repo tried to implement a keyboard device driver using BIOS calls and interrupts as a bootable hard disk in a virtual machine.

## technologies 
- Notepad++
- Nasm
- Oracle VM virtual box

## download
you can download the latest version of [notepad++](https://notepad-plus-plus.org/download/v7.6.3.html) , [nasm](https://www.nasm.us/pub/nasm/releasebuilds/?C=M;O=D) and [virtual box](https://www.virtualbox.org/wiki/Downloads) for windows
## code
- after writing your code you can convert it to vhd extension by running nasm shell and implemnt
```
nasm -fbin filename.asm -o filename.vhd
```
then you can add the bootable hard disk as shown in [demo](#demo)

## featurs
- implement a keyboard device driver as bootable hard disk in virtual machine
- the keyboard can write an english text. highligh it . copy or cut and paste it and also delete it.

## demo
### add driver to virtualbox
![alt text](https://github.com/ezecson/keyboard-device-in-assembly/blob/master/demo/setup%20driver%20in%20virtualbox.gif)

some pc face problems when running the device driver in virtualbox. to solve that problem just modify the accleration in setting of that driver 

![alt text](https://github.com/ezecson/keyboard-device-in-assembly/blob/master/demo/vm%20virtualbox%20setting.JPG)

### running the device driver 
![alt text](https://github.com/ezecson/keyboard-device-in-assembly/blob/master/demo/running%20the%20driver.gif)

