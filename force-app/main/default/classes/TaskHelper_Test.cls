/**
 * @description Test class TaskHelper Apex Class
 * @author
 * @since
 */
@IsTest
public with sharing class TaskHelper_Test {
  @testSetup
  private static void testSetup() {
    System.runAs(new User(Id = UserInfo.getUserId())) {
      Profile p = [
        SELECT id
        FROM Profile
        WHERE Name = 'Standard User'
      ];

      User activationUser = new user(
        alias = 'test123',
        email = 'test123@noemail.com',
        Emailencodingkey = 'UTF-8',
        FirstName = 'FName',
        LastName = 'Testing',
        languagelocalekey = 'en_US',
        localesidkey = 'en_IN',
        profileid = p.Id,
        country = 'India',
        timezonesidkey = 'Asia/Kolkata',
        username = 'active@noemail.com'
      );
      insert activationUser;

      User nonactivationUser = new user(
        alias = 'test123',
        email = 'test123@noemail.com',
        Emailencodingkey = 'UTF-8',
        FirstName = 'FName',
        LastName = 'Testing',
        languagelocalekey = 'en_US',
        localesidkey = 'en_IN',
        profileid = p.Id,
        country = 'India',
        timezonesidkey = 'Asia/Kolkata',
        username = 'nonactive@noemail.com'
      );
      insert nonactivationUser;

      PermissionSet ps = [
        SELECT Id
        FROM PermissionSet
        WHERE Name = 'CQ_Account_Admin'
      ];
      insert new PermissionSetAssignment(
        AssigneeId = activationUser.Id,
        PermissionSetId = ps.Id
      );
    }
    Test.startTest();
    User permUser = [
      SELECT Id
      FROM User
      WHERE username = 'active@noemail.com'
    ];

    Account testAccount = new Account(
      Name = 'Account Name',
      AccountNumber = 'ACC012',
      OwnerId = permUser.Id
    );
    insert testAccount;

    User nonPermUser = [
      SELECT Id
      FROM User
      WHERE username = 'nonactive@noemail.com'
    ];
    Account testAccount_nonActive = new Account(
      Name = 'Account Name',
      AccountNumber = 'ACC0123',
      OwnerId = nonPermUser.Id
    );
    insert testAccount_nonActive;
    Test.stopTest();

  }

  @isTest
  private static void testPermissionAssignedTrue() {
    // Test data setup
    Id userId = [SELECT Id FROM User WHERE username = 'nonactive@noemail.com']
    ?.Id;
    // Actual test
    Test.startTest();
    Boolean isAssigned = TaskHelper.checkIfUserHasAssignedPermissionSet(
      userId,
      'CQ_Account_Admin'
    );
    Test.stopTest();

    // Asserts
    System.assertEquals(
      false,
      isAssigned,
      'Permission Set assigned to Non Active user'
    );
  }

  @isTest
  private static void testPermissionAssignedFalse() {
    // Test data setup
    Id userId = [SELECT Id FROM User WHERE username = 'active@noemail.com']?.Id;
    // Actual test
    Test.startTest();
    Boolean isAssigned = TaskHelper.checkIfUserHasAssignedPermissionSet(
      userId,
      'CQ_Account_Admin'
    );
    Test.stopTest();

    // Asserts
    System.assertEquals(
      true,
      isAssigned,
      'Permission Set not assigned to Non Active user'
    );
  }

  @isTest
  private static void testactivateAccount() {
    // Test data setup
    List<Task> reviewTasks = [SELECT Id, Description, WhatId, OwnerId FROM Task];
    // Actual test
    Test.startTest();
    TaskHelper.activateAccount(reviewTasks);
    Test.stopTest();

    // Asserts
    Account acc = [
      SELECT Id, Active__c
      FROM Account
      WHERE Id = :reviewTasks[0].WhatId
    ];

    System.assertEquals(true, acc.Active__c, 'Account Not yet activated');
  }
}
