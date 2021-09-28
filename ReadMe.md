The script run_analysis.R contains functions for the analysis of the UCI HAR Dataset provided with the assignment.

The script contains two functions, computeaverages() and readdatafromfiles(), which do not require arguments. To run the script, make sure that the directory which contains run_analysis.R contains the folder UCI HAR Dataset.

The folder UCI HAR Dataset must contain: files activity_labels.txt, features.txt, folders test and train. The folder train must contain the files subject_train.txt, X_train.txt, y_train.txt. The folder test must contain the files subject_test.txt, X_test.txt, y_test.txt. 

To run the script, load the function into the R environment by "source" command, and call

computeaverages()

The script performs the following steps:
1. Calls readdatafromfiles function which returns a tidy dataset consisting of columns: SubjectId, TrainingLabel(numerical identifier of an activity as in the file activity_labels.txt), columns with means and standard deviations of variables measured in the experiments.
2. Computes averages of the values of these variables for each subject and each activity.
3. Substitutes the column with numerical identifiers of activities by their names.
4. Returns the dataset with computed averages.

The function readdatafromfiles performs the following steps:
1. Reads the file features.txt into a dataframe, and deletes from the dataframe the rows which do not correspond to measurements of a mean or a standard deviation.
2. Reads the data for the training group from the file X_train and removes the columns which do not correspond to measurements of the mean or standard deviation, matching the sequential number of a column to the number of a feature in features.txt.
3. Gives names to the columns in the resulting dataset using features.txt.
4. Reads the data for subjects and types of activity from the files subject_train and y_train and merges these data as columns of a common dataframe.
5. Repeats the steps 2-5 for the test group, reading from files X_test, subject_test and y_test. 
6. Merges rows of the dataframes obtained in steps 5 and 6 into a single dataframe.
7. Returns the result of step 6.
