import React from 'react'
import { mount } from 'enzyme'
import SongRequest from '../songRequest'
const expect = require('chai').expect
const sinon = require('sinon')

describe('SongRequest Component', () => {
  it('should render with values', () => {
    const props = {
      input: {
        value: [
          {
            label: 'Mexican Guitars by The Menzingers',
            value: 'Mexican Guitars by The Menzingers'
          },
          {
            label: 'Sorry We Steal by Arrogant Sons of Bitchs',
            value: 'Sorry We Steal by Arrogant Sons of Bitchs'
          },
        ],
      }
    }
    const component = mount(<SongRequest {...props} />)
    expect(component.find('.Select').hasClass('Select--multi')).to.be.true
    expect(component.find('.Select').hasClass('is-searchable')).to.be.true
    expect(component.find('.Select').hasClass('has-value')).to.be.true
    expect(component.find('.Select-value-label').first().text()).to.contain('Mexican Guitars')
    expect(component.find('.Select-value-label').last().text()).to.contain('Sorry We Steal')
  });
  it('should render without values', () => {
    const props = {
      input: {
        value: [
        ],
      }
    }
    const component = mount(<SongRequest {...props} />)
    expect(component.find('.Select').hasClass('Select--multi')).to.be.true
    expect(component.find('.Select').hasClass('is-searchable')).to.be.true
    expect(component.find('.Select').hasClass('has-value')).to.be.false
    expect(component.contains('.Select-value-label')).to.be.false
  });
})