angular.module 'mnoEnterpriseAngular'
.controller('CommentModal', ($scope, $uibModalInstance, testimonial) ->

  $scope.commentText = ''

  # Close the current modal
  $scope.closeModal = ->
    $uibModalInstance.dismiss()

  $scope.submitIteraction = ->
    testimonial.comments.push({text: $scope.commentText})
    $uibModalInstance.dismiss()

  return
)
