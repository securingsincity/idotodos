import {validateForm, validateUser} from '../validation'
const expect = require('chai').expect;

describe('validateForm', () => {
  it('it should fail if any user has no first name', () => {
    const state = {guests: [{id: 1, firstName: '', lastName: 'foo', attending: false}, {id: 2, firstName: 'baz', lastName: 'foo', attending: false}]}
    expect(validateForm(state)).to.deep.equal({
      hasErrors: true,
      guests: [
      {
        id: 1,
        firstName: true,
        lastName: false,
        hasErrors: true,
      },
      {
        id: 2,
        firstName: false,
        lastName: false,
        hasErrors: false,
      },
      ]
    })
  });
});

describe('validateUser', () => {
  it('it should fail if a user doenst have a first name', () => {
    expect(validateUser({id: 1, firstName: '', lastName: 'foo', attending: false})).to.deep.eq({id: 1, firstName: true, lastName: false, hasErrors: true})
  });
  it('it should fail if a user doenst have a last name', () => {
    expect(validateUser({id: 1, firstName: 'foo', lastName: '', attending: false})).to.deep.eq({id:1, firstName: false, lastName: true, hasErrors: true})
  });

  it('it should pass if a user has a last name', () => {
    expect(validateUser({id: 2, firstName: 'foo', lastName: 'bar', attending: false})).to.deep.eq({id: 2, firstName: false, lastName: false, hasErrors: false})
  });
});