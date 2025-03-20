package com.example.model;

public class Name {
  private String firstName;
  private String lastName;
  private String middleName;

  public Name() {
  }

  public Name(String firstName, String lastName, String middleName) {
    this.firstName = firstName;
    this.lastName = lastName;
    this.middleName = middleName;
  }

  // getters and setters
  public String getFirstName() {
    return firstName;
  }
  public void setFirstName(String firstName) {
    this.firstName = firstName;
  }
  public String getLastName() {
    return lastName;
  }
  public void setLastName(String lastName) {
    this.lastName = lastName;
  }
  public String getMiddleName() {
    return middleName;
  }
  public void setMiddleName(String middleName) {
    this.middleName = middleName;
  }
}
