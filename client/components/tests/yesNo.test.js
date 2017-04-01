import React from 'react'
import { mount } from 'enzyme'
import YesNo from '../yesNo'
const expect = require('chai').expect
const sinon = require('sinon')
describe('YesNo Component', () => {
  it('Should render', () => {
    const props = {
      input: {
        value: true,
      }
    }
    const component = mount(<YesNo {...props} />)
    expect(component.find('input').first().props().checked).to.be.true
    expect(component.find('input').last().props().checked).to.be.false
  });
  it('Should render other checked', () => {
    const props = {
      input: {
        value: false,
      }
    }
    const component = mount(<YesNo {...props} />)
    expect(component.find('input').last().props().checked).to.be.true
    expect(component.find('input').first().props().checked).to.be.false
  });
  it('Should call onchange with true if the first is clicked', () => {
    const onChange = sinon.spy()
    const props = {
      input: {
        value: false,
        onChange
      }
    }
    const component = mount(<YesNo {...props} />)
    component.find('input').first().simulate("change")
    expect(onChange.calledWith(true)).to.be.true
  });

  it('Should call onchange with true if the last is clicked', () => {
    const onChange = sinon.spy()
    const props = {
      input: {
        value: false,
        onChange
      }
    }
    const component = mount(<YesNo {...props} />)
    component.find('input').last().simulate("change")
    expect(onChange.calledWith(false)).to.be.true
  });
});