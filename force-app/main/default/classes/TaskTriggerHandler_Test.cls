/**
 * @description
 * @author
 * @since
 */
@IsTest
public with sharing class TaskTriggerHandler_Test {
  @testSetup
  private static void testSetup() {
    Profile p = [
      SELECT id
      FROM Profile
      WHERE Name = 'Standard User'
    ];

    User activationUser = new user(
      alias = 'test123',
      email = 'test123@noemail.com',
      Emailencodingkey = 'UTF-8',
      FirstName = 'Nahush',
      LastName = 'Testing',
      languagelocalekey = 'en_US',
      localesidkey = 'en_IN',
      profileid = p.Id,
      country = 'India',
      timezonesidkey = 'Asia/Kolkata',
      username = 'test_g@noemail.com'
    );
    insert activationUser;

    PermissionSet ps = [
      SELECT Id
      FROM PermissionSet
      WHERE Name = 'CQ Account Admin'
    ];
    insert new PermissionSetAssignment(
      AssigneeId = activationUser.Id,
      PermissionSetId = ps.Id
    );

    Account testAccount = new Account(
      Name = 'Account Name',
      AccountNumber = 'ACC012',
      OwnerId = activationUser.Id
    );
    insert testAccount;
  }

  @isTest
  private static void testPermissionSetError() {
    // Test data setup
    Id accountId = [SELECT Id FROM Account LIMIT 1]?.Id;

    List<Task> reviewTaskList = [
      SELECT Id, Status
      FROM Task
      WHERE WhatId = :accountId
    ];
    reviewTaskList[0].Description = 'Closing Task with comment';
    reviewTaskList[0].Status = 'Completed';

    // Actual test
    Test.startTest();
    try {
      update reviewTaskList;
    } catch (Exception e) {
      System.assert(
        e.getMessage()
          .contains(
            'You do not have the necessary permission to complete this task.'
          ),
        'Different Exception/Error thrown'
      );
    }
    Test.stopTest();
  }

  @IsTest
  static void testSuccessCompletion() {
    // Test data setup
    Id accountId = [SELECT Id FROM Account LIMIT 1]?.Id;

    List<Task> reviewTaskList = [
      SELECT Id, Status
      FROM Task
      WHERE WhatId = :accountId
    ];
    reviewTaskList[0].Description = 'Closing Task with comment';
    reviewTaskList[0].Status = 'Completed';

    User contextUser = [
      SELECT Id
      FROM User
      WHERE username = 'test_g@noemail.com'
    ];
    Test.startTest();
    System.runAs(contextUser) {
      update reviewTaskList;
    }
    Test.stopTest();

    List<Account> updatedAccounts = [
      SELECT Id, Active__c, Description
      FROM Account
    ];
    System.assertEquals(
      true,
      updatedAccounts.get(0).Active__c,
      'Account not Activated after Task completion'
    );
    System.assertEquals(
      reviewTaskList[0].Description,
      updatedAccounts.get(0).Description,
      'Comments not copied from task to Account Desc'
    );
  }
}
