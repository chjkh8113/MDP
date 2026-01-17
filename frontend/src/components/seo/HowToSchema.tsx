interface HowToStep {
  name: string;
  text: string;
  image?: string;
}

interface HowToSchemaProps {
  name: string;
  description: string;
  totalTime?: string; // ISO 8601 duration format, e.g., "PT10M" for 10 minutes
  steps: HowToStep[];
  image?: string;
}

export function HowToSchema({ name, description, totalTime, steps, image }: HowToSchemaProps) {
  const howToSchema = {
    "@context": "https://schema.org",
    "@type": "HowTo",
    "name": name,
    "description": description,
    ...(totalTime && { "totalTime": totalTime }),
    ...(image && { "image": image }),
    "step": steps.map((step, index) => ({
      "@type": "HowToStep",
      "position": index + 1,
      "name": step.name,
      "text": step.text,
      ...(step.image && { "image": step.image }),
    })),
  };

  return (
    <script
      type="application/ld+json"
      dangerouslySetInnerHTML={{ __html: JSON.stringify(howToSchema) }}
    />
  );
}

// Pre-defined HowTo content for vocabulary learning
export const vocabularyHowTo = {
  name: "چگونه با فلش‌کارت MDP لغات کنکور ارشد را یاد بگیریم",
  description: "راهنمای گام به گام استفاده از سیستم فلش‌کارت هوشمند MDP برای یادگیری لغات تخصصی کنکور کارشناسی ارشد با الگوریتم SM-2",
  totalTime: "PT15M",
  steps: [
    {
      name: "ورود به بخش تمرین لغات",
      text: "از صفحه اصلی MDP، روی دکمه 'تمرین لغات' کلیک کنید تا وارد سیستم فلش‌کارت شوید.",
    },
    {
      name: "مشاهده کارت جدید یا مرور",
      text: "سیستم به صورت خودکار کارت‌های جدید یا کارت‌هایی که زمان مرور آن‌ها رسیده را نمایش می‌دهد.",
    },
    {
      name: "مطالعه لغت انگلیسی",
      text: "لغت انگلیسی را مشاهده کنید و سعی کنید معنی فارسی آن را به یاد بیاورید.",
    },
    {
      name: "نمایش پاسخ",
      text: "روی کارت کلیک کنید تا معنی فارسی و تلفظ لغت نمایش داده شود.",
    },
    {
      name: "ارزیابی یادگیری",
      text: "یکی از گزینه‌های 'دوباره'، 'سخت'، 'خوب' یا 'آسان' را انتخاب کنید. سیستم SM-2 بر اساس انتخاب شما، زمان مرور بعدی را تعیین می‌کند.",
    },
    {
      name: "کسب امتیاز و ادامه",
      text: "با هر مرور موفق XP کسب کنید و به کارت بعدی بروید. تمرین روزانه Streak شما را افزایش می‌دهد.",
    },
  ],
};

// Pre-defined HowTo content for taking a quiz
export const quizHowTo = {
  name: "چگونه در آزمون آنلاین MDP شرکت کنیم",
  description: "راهنمای شرکت در آزمون آنلاین سوالات کنکور کارشناسی ارشد در سایت MDP",
  totalTime: "PT5M",
  steps: [
    {
      name: "شروع آزمون",
      text: "از صفحه اصلی روی دکمه 'شروع آزمون' کلیک کنید یا از منو گزینه 'آزمون لغات' را انتخاب کنید.",
    },
    {
      name: "خواندن سوال",
      text: "سوال چهارگزینه‌ای نمایش داده می‌شود. سوال را با دقت بخوانید.",
    },
    {
      name: "انتخاب پاسخ",
      text: "روی گزینه‌ای که فکر می‌کنید صحیح است کلیک کنید.",
    },
    {
      name: "بررسی پاسخ",
      text: "دکمه 'بررسی' را بزنید. پاسخ صحیح با رنگ سبز و پاسخ اشتباه با رنگ قرمز مشخص می‌شود.",
    },
    {
      name: "مشاهده نتیجه",
      text: "در پایان آزمون، نمره کل و تعداد پاسخ‌های صحیح نمایش داده می‌شود.",
    },
  ],
};

// Pre-defined HowTo for browsing questions by topic
export const browseQuestionsHowTo = {
  name: "چگونه سوالات کنکور ارشد را بر اساس موضوع پیدا کنیم",
  description: "راهنمای جستجو و مرور سوالات کنکور کارشناسی ارشد بر اساس رشته، درس و مبحث در MDP",
  totalTime: "PT3M",
  steps: [
    {
      name: "انتخاب رشته تحصیلی",
      text: "از منوی 'رشته‌ها' رشته تحصیلی مورد نظر خود را انتخاب کنید (مثلاً مهندسی کامپیوتر).",
    },
    {
      name: "انتخاب درس",
      text: "از لیست دروس، درس مورد نظر را انتخاب کنید (مثلاً ساختمان داده).",
    },
    {
      name: "انتخاب مبحث",
      text: "مبحث خاصی که می‌خواهید تمرین کنید را انتخاب کنید (مثلاً درخت‌ها).",
    },
    {
      name: "مرور سوالات",
      text: "سوالات کنکور سال‌های مختلف در آن مبحث نمایش داده می‌شود. روی هر سوال کلیک کنید تا پاسخ تشریحی را ببینید.",
    },
  ],
};
