/// Step Event
var k=keyboard_lastkey;
var c=keyboard_lastchar;

if keyboard_check_pressed(vk_anykey)
{
    if (k==vk_backspace)
    {
        // delete last character
        argument0 = string_copy(argument0, 1, string_length(argument0)-1 );
    }
    else if (k==vk_enter) and (argument0!="")
    {
        // enter was pressed and input wasn't empty : do what have to be done here !
    }
    else if k>=97 and k<=122 or k>=48 and k<=57 or k==192
    {
        // 65-90  : upcase letters
        // 122-192 : lowercase letters
        // 48-57  : numbers
        // 192   : I don't remember :P
        // 32   : space
        // Add c to argument0
        argument0 = argument0 + c;
    }
}
return argument0
