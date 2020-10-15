// lib_running_average_filter.ks provides a function that will filter out noise from a dataset by storing a number of previous values of that dataset and outputting the average (mean) of those values.
// Copyright © 2015 KSLib team 
// Lic. MIT
//Authored by space_is_hard

//These functions will set up and implement a running
//average filter that will help filter out noise in a
//continuously-updating set of data. It's useful for
//removing noise from a dataset that is expected to remain
//relatively stable. It will lag behind any large or
//continuous changes in the dataset

@LAZYGLOBAL OFF.

//Builds the list that will be passed on to the filter
FUNCTION running_average_filter_init {
    PARAMETER
        maxLength,  //How many previous values should be stored and averaged
        initValue.  //What starting values to use to build the list of [maxLength] units long
    
    LOCAL inputList TO LIST().

    FROM {LOCAL i TO 0.} UNTIL i >= maxLength STEP {SET i TO i + 1.} DO {
        inputList:ADD(initValue).
    }.

    RETURN inputList.
    
}.

//Takes in a new value and spits out an average of it and the previous values
FUNCTION running_average_filter {
    PARAMETER
        inputList,  //The list we built with PA_filter_init
        newValue.   //The next value to tack onto the list
    
    inputList:REMOVE(0).        //Removes the first item and bumps the rest down
    inputList:ADD(newValue).    //Adds the new value onto the end
    
    //Adds all of the values in the list together
    LOCAL sum TO 0.
    FOR item IN inputList {
        SET sum TO sum + item.
    }.
    
    //Returns the average of all of the values in the list
    RETURN sum / inputList:LENGTH.
    
}.