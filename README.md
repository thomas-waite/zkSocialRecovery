# zKSocialRecovery

To get started:
1) Clone the repo
2) Run `yarn install`
3) To compile contracts, run `truffle compile --all`

Make sure you have `truffle` globally installed. To run tests, have `ganache-cli` globally installed before running `yarn test`.

## Running UI

```
solui view --spec contracts/ui.json --artifacts build/contracts
```

### Updating logos

- Seach the logos you like at https://icons8.com/
- Save icon with pixel size 96px
- Upload the image into https://imgbb.com/
- Copy image url 
- Replace image url inside ui.json

eg:

```
    {
      "id": "view",
      "title": "View wallet state",
      "description": "View wallet state.",
      "image": {
        "url": "https://i.ibb.co/hLmm9mp/icons8-wallet-96.png"
      },
```

### Adding more UI

Read [the f**king doc](https://solui.dev/docs/specification)