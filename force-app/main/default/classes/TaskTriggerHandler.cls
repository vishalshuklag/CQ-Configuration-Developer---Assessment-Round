public with sharing class TaskTriggerHandler {
    //Variables
    private boolean triggerIsExecuting;
    private integer triggerSize;
    
    //Parameterized Constructor
    public TaskTriggerHandler(boolean triggerIsExecuting, integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
    }

    @SuppressWarnings('PMD.ExcessiveParameterList')
    public void beforeUpdate(
        List<Task> oldTaskList,
        List<Task> newTaskList,
        Map<Id, Task> oldTaskMap,
        Map<Id, Task> newTaskMap
    ) {
        final String permissionSetName = 'CQ_Account_Admin';

        // ! Should we use Custom Permission Sets or CustomPermission? I'm just validating the Custom Permission set assignment, if we just need to validated this then it can be implemeted with CustomPermission
        // TODO:: Validate if Current User has CQ Account Admin Permission set
        // Only the members of permission set CQ Account Admin (Create a new permission set) can complete the task and activate accounts
        Boolean userHasTaskCompletePerm = TaskHelper.checkIfUserHasAssignedPermissionSet(UserInfo.getUserId(), permissionSetName);
        for (Task tsk : newTaskList) {
            if (tsk.Status == 'Completed' && tsk.WhatId != null && tsk.Subject.startsWith('Review Account-')) {
                if (!userHasTaskCompletePerm) {
                    tsk.addError('You do not have the necessary permission to complete this task.');
                }
            }
        }
    }

    @SuppressWarnings('PMD.ExcessiveParameterList')
    public void afterUpdate(
        List<Task> oldTaskList,
        List<Task> newTaskList,
        Map<Id, Task> oldTaskMap,
        Map<Id, Task> newTaskMap
    ) {
        List<Task> closedTasksList = new List<Task>();

        for (Task tsk : newTaskList) {
            if (tsk.Status == 'Completed' && tsk.Subject.startswith('Review Account')) {
                closedTasksList.add(tsk);
            }
        }

        if (!closedTasksList.isEmpty()) {
            TaskHelper.activateAccount(closedTasksList);
        }
    }
}