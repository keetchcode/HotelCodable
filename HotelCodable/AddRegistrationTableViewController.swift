//
//  AddRegistrationTableViewController.swift
//  HotelCodable
//
//  Created by Skyler Robbins on 10/29/24.
//

import UIKit

class AddRegistrationTableViewController: UITableViewController, SelectRoomTypeTableViewControllerDelegate {
  func selectRoomTypeTableViewController(
    _ controller: SelectRoomTypeTableViewController,
    didSelect roomType: RoomType
  ) {
    self.roomType = roomType
    updateRoomType()
  }

  @IBOutlet weak var firstNameTextField: UITextField!
  @IBOutlet weak var lastNameTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!

  @IBOutlet weak var numberOfAdultsLabel: UILabel!
  @IBOutlet weak var numberOfAdultsStepper: UIStepper!
  @IBOutlet weak var numberOfChildrenLabel: UILabel!
  @IBOutlet weak var numberOfChildrenStepper: UIStepper!

  @IBOutlet weak var wifiSwitch: UISwitch!

  @IBOutlet weak var checkInDateLabel: UILabel!
  @IBOutlet weak var checkInDatePicker: UIDatePicker!
  @IBOutlet weak var checkOutDateLabel: UILabel!
  @IBOutlet weak var checkOutDatePicker: UIDatePicker!

  @IBOutlet weak var roomTypeLabel: UILabel!

  var roomType: RoomType?

  let checkInLabelCellIndexPath = IndexPath(row: 0, section: 1)
  let checkInDatePickerCellIndexPath = IndexPath(row: 1, section: 1)
  let checkOutLabelCellIndexPath = IndexPath(row: 2, section: 1)
  let checkOutDatePickerCellIndexPath = IndexPath(row: 3, section: 1)

  var isCheckInDatePickerVisible: Bool = false {
    didSet {
      checkInDatePicker.isHidden = !isCheckInDatePickerVisible
    }
  }
  var isCheckOutDatePickerVisible: Bool = false {
    didSet {
      checkOutDatePicker.isHidden = !isCheckOutDatePickerVisible
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    let midnightToday = Calendar.current.startOfDay(for: Date())
    checkInDatePicker.minimumDate = midnightToday
    checkInDatePicker.date = midnightToday
    updateNumberOfGuests()
    updateDateViews()
    updateRoomType()
  }

//  @IBAction func donePressed(_ sender: UIBarButtonItem) {
//    print(firstNameTextField.text ?? "")
//    print(lastNameTextField.text ?? "")
//    print(emailTextField.text ?? "")
//    print(numberOfAdultsLabel.text ?? "")
//    print(numberOfChildrenLabel.text ?? "")
//    print(wifiSwitch.isOn)
//    print(checkInDateLabel.text ?? "")
//    print(checkOutDateLabel.text ?? "")
//    print(roomType?.name ?? "Not Set")
//
//  }

  func updateNumberOfGuests() {
    numberOfAdultsLabel.text = "\(Int(numberOfAdultsStepper.value))"
    numberOfChildrenLabel.text = "\(Int(numberOfChildrenStepper.value))"
  }

  @IBAction func stepperPressed(_ sender: UIStepper) {
    updateNumberOfGuests()
  }

  func updateDateViews() {
    checkOutDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: checkInDatePicker.date)

    checkInDateLabel.text = checkInDatePicker.date.formatted(date: .abbreviated, time: .omitted)
    checkOutDateLabel.text = checkOutDatePicker.date.formatted(date: .abbreviated, time: .omitted)

  }

  @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
    updateDateViews()
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath {
    case checkInDatePickerCellIndexPath where isCheckInDatePickerVisible == false:
      return 0
    case checkOutDatePickerCellIndexPath where isCheckOutDatePickerVisible == false:
      return 0
    default:
      return UITableView.automaticDimension
    }
  }

  override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath {
    case checkInDatePickerCellIndexPath, checkOutDatePickerCellIndexPath:
      return 216
    default:
      return UITableView.automaticDimension
    }
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    switch indexPath {
    case checkInLabelCellIndexPath where !isCheckOutDatePickerVisible:
      isCheckInDatePickerVisible.toggle()
    case checkOutLabelCellIndexPath where !isCheckInDatePickerVisible:
      isCheckOutDatePickerVisible.toggle()
    case checkInLabelCellIndexPath, checkOutLabelCellIndexPath:
      isCheckInDatePickerVisible.toggle()
      isCheckOutDatePickerVisible.toggle()
    default:
      return
    }

    tableView.beginUpdates()
    tableView.endUpdates()
  }


  func updateRoomType() {
    if let roomType = roomType {
      roomTypeLabel.text = roomType.name
    } else {
      roomTypeLabel.text = "Not Set"
    }
  }


  @IBSegueAction func selectRoomType(_ coder: NSCoder) -> SelectRoomTypeTableViewController? {
    let selectRoomTypeController = SelectRoomTypeTableViewController(coder: coder)
    selectRoomTypeController?.delegate = self
    selectRoomTypeController?.roomType = roomType


    return selectRoomTypeController
  }

  var registration: Registration? {

    guard let roomType = roomType else { return nil }

    let firstName = firstNameTextField.text ?? ""
    let lastName = lastNameTextField.text ?? ""
    let email = emailTextField.text ?? ""
    let checkInDate = checkInDatePicker.date
    let checkOutDate = checkOutDatePicker.date
    let numberOfAdults = Int(numberOfAdultsStepper.value)
    let numberOfChildren = Int(numberOfChildrenStepper.value)
    let hasWifi = wifiSwitch.isOn

    return Registration(firstName: firstName,
                       lastName: lastName,
                       email: email,
                       checkInDate: checkInDate,
                       checkOutDate: checkOutDate, numberOfAdults: numberOfAdults, numberOfChildren: numberOfChildren, wantsWifi: hasWifi,
                       roomType: roomType)
  }

  @IBAction func cancelButtonTapped() {
    dismiss(animated: true, completion: nil)
  }

}
