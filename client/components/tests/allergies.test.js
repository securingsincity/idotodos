import React from 'react'
import { mount } from 'enzyme'
import Allergies from '../allergies'
const expect = require('chai').expect
describe('Allergies Form', () => {
  it('should render based on redux-form inputs', () => {
    const props = {
      input: {
        value: 'beets',
      }
    }
    const component = mount(<Allergies {...props} />)
    expect(component.find('input').props().value).to.eq('beets')
  });
});
