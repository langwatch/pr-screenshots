$ git rev-parse HEAD
4c702ac4719a2badb53330d798e7fb366ea75243
$ go version
go version go1.27.4 linux/amd64
$ just -g wrap ': tsc ; go run ./cmd/readmegen --check'
readmegen: unresolved values (shown with ≈): 9 browser, 2 config, 11 process manager, 6 rest, 1 schema, 4 secret, 2 stores, 4 subscriber, 5 trpc
# peak = max summed VmRSS of main.mts/readmegen processes, sampled every 0.5s
exit=0 peak_rss_MB=1148
