import rsvp from '../rsvp'
import Immutable, { Map, fromJS } from 'immutable';
const expect = require('chai').expect;
const uuidV4 = require('uuid/v4');
describe('RSVP Reducers', () => {
  it('Default should return initial state', () => {
    const initialState = fromJS({
      guests: [],
      songChoices: [],
      maxGuests: 0,
    })
    expect(rsvp(undefined, {})).to.deep.equal(initialState)
  });

  it('initial load should set guests and maxGuests', () => {
    const guests = [
      {id: 1, firstName: "James", lastName: "Hrisho"},
      {id: 2, firstName: "NotJames", lastName: "Hrisho"},
    ]
    const maxGuests = 3
    const action = {
      guests,
      maxGuests,
      type: "INITIAL_LOAD"
    }
    const result = rsvp(undefined, action);
    const expected = fromJS({
      guests,
      maxGuests,
      songChoices: []
    })
    expect(result.get("guests")).to.deep.equal(expected.get("guests"));
    expect(result.get("maxGuests")).to.deep.equal(expected.get("maxGuests"));
  });

  it('first name change if guest exists', () => {
    const guests = [
      {id: 1, firstName: "James", lastName: "Hrisho"},
      {id: 2, firstName: "NotJames", lastName: "Hrisho"},
    ]
    const maxGuests = 3
    const action = {
      guests,
      maxGuests,
      type: "INITIAL_LOAD"
    }
    const state = rsvp(undefined, action);

    const second_action = {
      id: 2,
      name: "Sara",
      type: "FIRST_NAME_CHANGED"
    }

    const result = rsvp(state, second_action)
    const expected = [
      {id: 1, firstName: "James", lastName: "Hrisho"},
      {id: 2, firstName: "Sara", lastName: "Hrisho"},
    ]
    expect(result.get("guests").toJS()).to.deep.equal(expected)
  })

  it('first name change if guest does not exists', () => {
    const guests = [
      {id: 1, firstName: "James", lastName: "Hrisho"},
    ]
    const maxGuests = 3
    const action = {
      guests,
      maxGuests,
      type: "INITIAL_LOAD"
    }
    const state = rsvp(undefined, action);

    const second_action = {
      id: 2,
      name: "Sara",
      type: "FIRST_NAME_CHANGED"
    }

    const result = rsvp(state, second_action)
    const expected = [
      {id: 1, firstName: "James", lastName: "Hrisho"},
    ]
    expect(result.get("guests").toJS()).to.deep.equal(expected)
  })

  it('last name change if guest exists', () => {
    const guests = [
      {id: 1, firstName: "James", lastName: "Hrisho"},
      {id: 2, firstName: "NotJames", lastName: "Hrisho"},
    ]
    const maxGuests = 3
    const action = {
      guests,
      maxGuests,
      type: "INITIAL_LOAD"
    }
    const state = rsvp(undefined, action);

    const second_action = {
      id: 2,
      name: "Sara",
      type: "LAST_NAME_CHANGED"
    }

    const result = rsvp(state, second_action)
    const expected = [
      {id: 1, firstName: "James", lastName: "Hrisho"},
      {id: 2, firstName: "NotJames", lastName: "Sara"},
    ]
    expect(result.get("guests").toJS()).to.deep.equal(expected)
  })

   it('last name change if guest does not exists', () => {
    const guests = [
      {id: 1, firstName: "James", lastName: "Hrisho"},
    ]
    const maxGuests = 3
    const action = {
      guests,
      maxGuests,
      type: "INITIAL_LOAD"
    }
    const state = rsvp(undefined, action);

    const second_action = {
      id: 2,
      name: "Sara",
      type: "LAST_NAME_CHANGED"
    }

    const result = rsvp(state, second_action)
    const expected = [
      {id: 1, firstName: "James", lastName: "Hrisho"},
    ]
    expect(result.get("guests").toJS()).to.deep.equal(expected)
  })

  it('Adds guest', () => {
    const guests = [
      {id: 1, firstName: "James", lastName: "Hrisho"},
    ]
    const maxGuests = 3
    const action = {
      guests,
      maxGuests,
      type: "INITIAL_LOAD"
    }
    const state = rsvp(undefined, action)
    const second_action = {
      type: "ADD_GUEST"
    }
    const result = rsvp(state, second_action)
    expect(result.get("guests").size).to.deep.equal(2)

    const secondResult = rsvp(result, second_action)
    expect(secondResult.get("guests").size).to.deep.equal(3)
  });
});
