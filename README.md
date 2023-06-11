
<h1 align="center">
  
  <br>
<img width="200" alt="pStringMem" src="https://github.com/TalMizrahii/Assembly-Pstrings/assets/103560553/cc350fec-e689-4cd4-bdac-b3986187c914">

  <br>
</h1>

<h4 align="center">This gitHub repository is for the Third assignment given in Computer Systems course, Bar Ilan University.


<p align="center">
  <a href="#description">Description</a> •
  <a href="#installing-and-executing">Installing And Executing</a> •
  <a href="#author">Author</a> 
</p>

## Description

This is my second assembly project for the Computer Systems course at Bar Ilan university.

The project's purpose is to practice more advanced assembly concepts. It focuses on the pstrings manipulations and information. 

pstring is a struct that contains a string and its length,  

![ps](https://user-images.githubusercontent.com/103560553/208872555-2f3b3659-a735-4d6c-af65-82059009456e.PNG)

Which will be stored in the memory as follow:

<img width="127" alt="pStringMem" src="https://user-images.githubusercontent.com/106544582/237052461-69eadeb1-7127-4718-9a3e-0bc203e5589d.png">


The program is made of 3 files:
 * The run_main file.s - In charge of receiving two pstrings and a choice.
 * The func_select.s file - In charge of the control flow of the program, executing the user request by the selected choice.
 * The pstring.s file - A pstring library made for the func_select.s to use for the pstrings operations.
 
 
 The func_select.s file is a switch case, which receives 5 cases:
 * Case 31: Prints the two pstrings length.

![31](https://user-images.githubusercontent.com/103560553/208873496-e67ab793-7b85-49d5-8d2f-042d2243b3f5.PNG)

 * Case 32: Ask the user for two chars - old char and new char, replace them in both pstrings, and print the result.
 
 ![3233](https://user-images.githubusercontent.com/103560553/208874092-4316b3c6-085d-4919-b508-20bdebae58e4.PNG)
 
  * Case 35:  Ask the user for two numbers (i and j), copy from the second pstring the [i:j] chars to the first pstring, and print the result.
  
  ![35](https://user-images.githubusercontent.com/103560553/208874856-f1af6288-e56a-47d1-b267-4888c1ff2edd.PNG)

 * Case 36: Replace all upper case letters with lower case letters and lower case letters with upper case letters.
 
 ![36](https://user-images.githubusercontent.com/103560553/208875494-aea0e52b-3686-4ef5-97a7-a323848c703f.PNG)

 * Case 37: Ask the user for two numbers (i and j) and implement strijcmp on the first and second pstrings. If pstring1[i:j] is larger lexicography than pstring2[i:j], print 1. If they are equal, print 0. Otherwise, print -1.
 
 ![37](https://user-images.githubusercontent.com/103560553/208877270-289d9512-e9b3-422d-a8c3-3f7b5fd32fc4.PNG)

If any other choice of case was made, the program will print "invalid option!"
 
## Installing And Executing

To clone and run this application, you'll need to use [Git](https://git-scm.com) and the [gcc](https://gcc.gnu.org/) compiler. From your command line:

```bash
# Clone this repository.
$ git clone https://github.com/TalMizrahii/Assembly-Pstrings

# Go into the repository.
$ cd Assembly-Pstrings

# Compile the program.
$ gcc run_main.s func_select.s pstring.s

# Run the program (Linux).
$ ./a.out
```

## Author
* [@Tal Mizrahi](https://github.com/TalMizrahii)


