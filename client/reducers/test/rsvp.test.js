import rsvp from '../rsvp'
const expect = require('chai').expect;
import { creators } from '../../actions/rsvp'
describe('RSVP Reducers', () => {
  it('Default should return initial state', () => {
    const initialState = {
      responded: false,
      showConfirmModal: false,
    }
    expect(rsvp(undefined, {})).to.deep.equal(initialState)
  });

  it('show confirm modal should set value to true', () => {
    const initialState = {
      responded: false,
      showConfirmModal: false,
    }
    expect(rsvp(initialState, {
      type: creators.SHOW_CONFIRM_MODAL,
    })).to.deep.equal({
      responded: false,
      showConfirmModal: true
    })
  });

  it('show confirm modal should set value to false', () => {
    const initialState = {
      responded: false,
      showConfirmModal: true,
    }
    expect(rsvp(initialState, {
      type: creators.HIDE_CONFIRM_MODAL,
    })).to.deep.equal({
      responded: false,
      showConfirmModal: false
    })
  });

  it('show confirm modal should set value to false', () => {
    const initialState = {
      responded: false,
      showConfirmModal: true,
    }
    expect(rsvp(initialState, {
      type: creators.RESPONDED,
    })).to.deep.equal({
      responded: true,
      showConfirmModal: true
    })
  });
});
