import rsvp from '../rsvp'
const expect = require('chai').expect;
const uuidV4 = require('uuid/v4');
describe('RSVP Reducers', () => {
  it('Default should return initial state', () => {
    const initialState = {
      responded: false,
      showConfirmModal: false,
    }
    expect(rsvp(undefined, {})).to.deep.equal(initialState)
  });
});
