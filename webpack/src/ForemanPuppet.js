import React from 'react';
import { BrowserRouter } from 'react-router-dom';
import ForemanPuppetRoute from './Router';

const ForemanPuppet = () => (
  <BrowserRouter>
    <ForemanPuppetRoute />
  </BrowserRouter>
);

export default ForemanPuppet;
