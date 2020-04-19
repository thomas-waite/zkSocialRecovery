function encodeProof(proofObject) {
    const { proof: { a, b, c }, inputs } = proofObject;
    const flatB = b.flat();

    const encodedProof = a.concat(flatB, c, inputs);
    encodedProof.forEach((element) => element.slice(2));

    return encodedProof;
}

module.exports = {
    encodeProof,
};
