/* global describe, contract, beforeEach, it */

import { expect } from 'chai';
import * as Zokrates from 'zokrates-js';

describe('Zokrates proof generation', async () => {
    let zokrates;

    beforeEach(async () => {
        const zokrates = Zokrates.initialize();
    });

    it('should initialise zokrates', async () => {
        console.log('')
        expect(zokrates).to.equal();
    });
});