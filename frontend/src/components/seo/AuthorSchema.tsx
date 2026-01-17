import { Users, Award, BookOpen, Shield } from 'lucide-react';

const BASE_URL = process.env.NEXT_PUBLIC_SITE_URL || 'https://mdp.ir';

/**
 * Author/Organization schema for E-E-A-T signals
 * Since MDP is an educational platform, we use organization credentials
 */
export function AuthorSchema() {
  const authorSchema = {
    "@context": "https://schema.org",
    "@type": "Organization",
    "@id": `${BASE_URL}/#author`,
    "name": "تیم MDP",
    "url": BASE_URL,
    "description": "تیم MDP متشکل از متخصصین آموزشی و برنامه‌نویسان با تجربه در حوزه آموزش کنکور کارشناسی ارشد",
    "knowsAbout": [
      "کنکور کارشناسی ارشد",
      "آموزش آنلاین",
      "سیستم‌های یادگیری هوشمند",
      "الگوریتم SM-2",
      "مهندسی کامپیوتر",
      "مهندسی برق",
    ],
    "memberOf": {
      "@type": "Organization",
      "name": "MDP - پلتفرم آمادگی کنکور ارشد",
    },
  };

  return (
    <script
      type="application/ld+json"
      dangerouslySetInnerHTML={{ __html: JSON.stringify(authorSchema) }}
    />
  );
}

/**
 * E-E-A-T credentials section - displays trust signals visually
 */
interface CredentialItem {
  icon: React.ReactNode;
  title: string;
  description: string;
}

const credentials: CredentialItem[] = [
  {
    icon: <BookOpen className="w-6 h-6 text-blue-600" />,
    title: "سوالات اصلی کنکور",
    description: "تمام سوالات مستقیماً از آزمون‌های رسمی سازمان سنجش استخراج شده‌اند",
  },
  {
    icon: <Award className="w-6 h-6 text-amber-600" />,
    title: "پاسخ‌های تشریحی معتبر",
    description: "پاسخ‌ها توسط متخصصین هر رشته بررسی و تأیید شده‌اند",
  },
  {
    icon: <Users className="w-6 h-6 text-green-600" />,
    title: "تیم متخصص",
    description: "تیم MDP متشکل از فارغ‌التحصیلان برتر دانشگاه‌های معتبر کشور",
  },
  {
    icon: <Shield className="w-6 h-6 text-purple-600" />,
    title: "رایگان و قابل اعتماد",
    description: "دسترسی کاملاً رایگان بدون نیاز به ثبت‌نام برای سوالات",
  },
];

interface CredentialsSectionProps {
  compact?: boolean;
}

export function CredentialsSection({ compact = false }: CredentialsSectionProps) {
  if (compact) {
    return (
      <div className="flex flex-wrap gap-3 justify-center">
        {credentials.map((item, index) => (
          <div
            key={index}
            className="flex items-center gap-2 bg-white px-3 py-2 rounded-full border border-gray-200 text-sm"
          >
            {item.icon}
            <span className="text-gray-700">{item.title}</span>
          </div>
        ))}
      </div>
    );
  }

  return (
    <section className="bg-gradient-to-b from-gray-50 to-white py-12 mt-12">
      <div className="container mx-auto px-4">
        <h2 className="text-xl font-bold text-gray-800 mb-2 text-center">
          چرا به MDP اعتماد کنید؟
        </h2>
        <p className="text-gray-600 text-center mb-8 max-w-2xl mx-auto">
          MDP با هدف کمک به داوطلبان کنکور ارشد، منابع معتبر و رایگان ارائه می‌دهد
        </p>

        <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-4 max-w-5xl mx-auto">
          {credentials.map((item, index) => (
            <div
              key={index}
              className="bg-white p-6 rounded-xl border border-gray-100 shadow-sm hover:shadow-md transition-shadow"
            >
              <div className="w-12 h-12 rounded-full bg-gray-50 flex items-center justify-center mb-4">
                {item.icon}
              </div>
              <h3 className="font-semibold text-gray-800 mb-2">{item.title}</h3>
              <p className="text-sm text-gray-600">{item.description}</p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}

/**
 * About the team section for E-E-A-T
 */
export function AboutTeamSection() {
  return (
    <section className="bg-white py-12 border-t border-gray-100">
      <div className="container mx-auto px-4">
        <div className="max-w-3xl mx-auto text-center">
          <h2 className="text-xl font-bold text-gray-800 mb-4">
            درباره تیم MDP
          </h2>
          <p className="text-gray-600 mb-6 leading-relaxed">
            MDP توسط تیمی از فارغ‌التحصیلان دانشگاه‌های برتر ایران توسعه یافته است.
            هدف ما فراهم کردن دسترسی رایگان و آسان به منابع کنکور کارشناسی ارشد برای
            همه داوطلبان است. سیستم یادگیری ما بر اساس الگوریتم علمی SM-2
            (تکرار فاصله‌دار) طراحی شده که اثربخشی آن در تحقیقات علمی تأیید شده است.
          </p>
          <div className="flex flex-wrap justify-center gap-4 text-sm text-gray-500">
            <span className="flex items-center gap-1">
              <span className="w-2 h-2 bg-green-500 rounded-full"></span>
              فعال از ۱۴۰۳
            </span>
            <span className="flex items-center gap-1">
              <span className="w-2 h-2 bg-blue-500 rounded-full"></span>
              سوالات ۵ سال اخیر
            </span>
            <span className="flex items-center gap-1">
              <span className="w-2 h-2 bg-purple-500 rounded-full"></span>
              ۱۰۰٪ رایگان
            </span>
          </div>
        </div>
      </div>
    </section>
  );
}
