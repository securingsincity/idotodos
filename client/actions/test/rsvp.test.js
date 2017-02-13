import { addGuest, initialLoad, onFirstNameChange, onLastNameChange} from '../rsvp'
const expect = require('chai').expect;
describe('RSVP Actions', () => {
  it('initialLoad shoul return guests and maxguest', () => {

    const guests = [
      {id: 1, firstName: "James", lastName: "Hrisho"},
      {id: 2, firstName: "NotJames", lastName: "Hrisho"},
    ]
    const maxGuests = 3
    const result = {
      guests,
      maxGuests,
      type: "INITIAL_LOAD"
    }
    expect(initialLoad(guests, maxGuests)).to.deep.equal(result)
  });
  it('first name change should return object', () => {
    const result = {
      id: 2,
      name: "James",
      type: "FIRST_NAME_CHANGED"
    }
    expect(onFirstNameChange(2, "James")).to.deep.equal(result)
  });
  it('last name change should return object', () => {
    const result = {
      id: 2,
      name: "James",
      type: "LAST_NAME_CHANGED"
    }
    expect(onLastNameChange(2, "James")).to.deep.equal(result)
  });

   it('add guest should return object', () => {
    const result = {
      type: "ADD_GUEST"
    }
    expect(addGuest()).to.deep.equal(result)
  });
});
