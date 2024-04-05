/**
 * @description Helper class of Task Trigger Handler Class
 * @author Vishal Shukla
 * @since 05/04/2024
 */
public with sharing class TaskHelper {
  /**
   * @description Activate the accounts for which the Task is completed & copy the Comments from completed task to it's related Account Description
   * @param closedTaskList
   */
  public static void activateAccount(List<Task> closedTaskList) {
    List<Account> accountsToActivate = new List<Account>();

    for (Task closedTask : closedTaskList) {
      Account acc = new Account(
        Id = closedTask.WhatId,
        Active__c = true,
        Description = closedTask.Description
      );

      accountsToActivate.add(acc);
    }

    if (!accountsToActivate.isEmpty()) {
      Database.insert(accountsToActivate, false);
    }
  }

  public static Boolean checkIfUserHasAssignedPermissionSet(
    Id contextUserId,
    String permissionSetName
  ) {
    List<PermissionSetAssignment> userPermissionSet = [
      SELECT Id
      FROM PermissionSetAssignment
      WHERE
        PermissionSet.Name = :permissionSetName
        AND AssigneeId = :contextUserId
      WITH SYSTEM_MODE
    ];

    return userPermissionSet.size() > 0;
  }
}
