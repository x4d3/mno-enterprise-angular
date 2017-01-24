angular.module 'mnoEnterpriseAngular'
.controller('QuestionModal', ($scope, $uibModalInstance, questions) ->

  $scope.questionText = ''

  # Close the current modal
  $scope.closeModal = ->
    $uibModalInstance.dismiss()

  $scope.submitQuestion = ->
    questions.questions.push({text: $scope.questionText, answers: []})

    $uibModalInstance.dismiss()

  return
)
