# README

## Database commands

```
rails generate scaffold Category name:string order:integer enabled:boolean quantity:integer
rails generate scaffold Exercise name:string image:string link:string category:references lift_scheme:integer
rails generate model ExerciseHistory exercise:references sets:integer reps:integer weight:integer success:boolean
rails generate scaffold_controller ExerciseHistory exercise:references sets:integer reps:integer weight:integer success:boolean
rails generate migration AddSequencePositionToExerciseHistories sequence_position:integer
rails generate migration AddWeightsToExercises weight:integer progression:integer
rails generate migration AddRepsSetsToExercises reps:integer sets:integer duration:integer rest_seconds:integer
```
