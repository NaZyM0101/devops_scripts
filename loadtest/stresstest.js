import http from 'k6/http';
import { check } from 'k6';

export const options = {
  scenarios: {
    high_rps: {
      executor: 'constant-arrival-rate',
      rate: 1000000, // Total requests per second (1,000 users x 1,000 requests per second)
      timeUnit: '1s', // Per second
      duration: '1m', // Run for 1 minute
      preAllocatedVUs: 1000, // Number of VUs to allocate
      maxVUs: 1100, // Maximum VUs to allocate in case of overflows
    },
  },
};

export default function () {
  const url = 'https://example.com'; // Replace with your target URL
  const res = http.get(url);

  check(res, {
    'is status 200': (r) => r.status === 200,
  });
}
