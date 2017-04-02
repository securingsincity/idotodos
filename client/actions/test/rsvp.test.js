import {  onResponse } from '../rsvp'
const expect = require('chai').expect;
describe('RSVP Actions', () => {

  it('onResponse should return object', () => {
    const result = {
      type: 'RESPONDED'
    }
    expect(onResponse()).to.deep.equal(result)
  });

});
