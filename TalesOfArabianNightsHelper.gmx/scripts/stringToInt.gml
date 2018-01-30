// Program to convert a string to an int
n = 0
originalLength = string_length(argument0)
for(i = 0; i < originalLength; i+=1)
{
  n *= 10
  n += argument0[i] - $30
}
return n
