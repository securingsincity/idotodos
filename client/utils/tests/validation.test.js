import {validateForm, validateUser} from '../validation'
const expect = require('chai').expect;

describe('validateForm', () => {
  it('it should fail if any guests has no first name', () => {
    const guest1 = {id: 1, firstName: '', lastName: 'foo', attending: false}
    const guest2 = {id: 2, firstName: 'bar', lastName: 'foo', attending: false}
    const results = validateForm({
      guests: [guest1, guest2]
    })

    expect(results).to.deep.equal({
      guests: [
        {firstName: 'Required', hasErrors: true},
        {}
      ]
    })
  });

  it('it should fail if any guests has no last name', () => {
    const guest1 = {id: 1, firstName: 'foo', lastName: 'foo', attending: false}
    const guest2 = {id: 2, firstName: 'bar', lastName: '', attending: false}
    const results = validateForm({
      guests: [guest1, guest2]
    })

    expect(results).to.deep.equal({
      guests: [
        {},
        {lastName: 'Required', hasErrors: true}
      ]
    })
  });

  it('it should fail if multiple guests has no last name', () => {
    const guest1 = {id: 1, firstName: 'foo', lastName: '', attending: false}
    const guest2 = {id: 2, firstName: 'bar', lastName: '', attending: false}
    const results = validateForm({
      guests: [guest1, guest2]
    })

    expect(results).to.deep.equal({
      guests: [
        {lastName: 'Required', hasErrors: true},
        {lastName: 'Required', hasErrors: true},
      ]
    })
  });

  it('it should pass if all guests are valid', () => {
    const guest1 = {id: 1, firstName: 'foo', lastName: 'foo', attending: false}
    const guest2 = {firstName: 'bar', lastName: 'foo', attending: false}
    const results = validateForm({
      guests: [guest1, guest2]
    })

    expect(results).to.deep.equal({})
  });
});

describe('validateUser', () => {
  it('it should fail if a user doenst have a first name', () => {
    expect(validateUser({id: 1, firstName: '', lastName: 'foo', attending: false})).to.deep.eq({
      firstName: 'Required',
      hasErrors: true
    })
  });
  it('it should fail if a user doenst have a last name', () => {
    expect(validateUser({id: 1, firstName: 'foo', lastName: '', attending: false})).to.deep.eq({
      lastName: 'Required',
      hasErrors: true
    })
  });

  it('it should pass if a user has a last name', () => {
    expect(validateUser({id: 2, firstName: 'foo', lastName: 'bar', attending: false})).to.deep.eq({})
  });
});